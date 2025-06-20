// ∴

import { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Tabs, TabsList, TabsTrigger, TabsContent } from '@/components/ui/tabs';
import { Textarea } from '@/components/ui/textarea';
import { Button } from '@/components/ui/button';
import { ScrollArea } from '@/components/ui/scroll-area';

const models = ['devstral:24b', 'codegeex4:latest', 'phi4-reasoning:plus'];

export default function BOB—zaddisensei() {
  const [activeModel, setActiveModel] = useState('devstral');
  const [input, setInput] = useState('');
  const [responses, setResponses] = useState({ devstral: [], codegeex4: [], phi4r: [] });
  const [sharedSummary, setSharedSummary] = useState('Shared summary will appear here.');

  const handleSend = () => {
    if (!input.trim()) return;
    const newEntry = { role: 'user', content: input };
    const newResponse = { role: activeModel, content: `[${activeModel} reply simulated]` };
    setResponses(prev => ({
      ...prev,
      [activeModel]: [...prev[activeModel], newEntry, newResponse],
    }));
    setInput('');
  };

  return (
    <div className="p-4 space-y-4">
      <Tabs value={activeModel} onValueChange={setActiveModel}>
        <TabsList>
          {models.map(m => (
            <TabsTrigger key={m} value={m}>{m}</TabsTrigger>
          ))}
        </TabsList>
        {models.map(m => (
          <TabsContent key={m} value={m}>
            <ScrollArea className="h-80 p-2 border rounded-xl space-y-2">
              {responses[m].map((msg, i) => (
                <Card key={i} className="p-2">
                  <CardContent>
                    <div className="text-xs text-muted-foreground">{msg.role}</div>
                    <div>{msg.content}</div>
                  </CardContent>
                </Card>
              ))}
            </ScrollArea>
          </TabsContent>
        ))}
      </Tabs>

      <Textarea
        placeholder="++ presence"
        value={input}
        onChange={e => setInput(e.target.value)}
      />
      <Button onClick={handleSend}>Send</Button>

      <Card className="mt-4">
        <CardContent>
          <div className="font-bold mb-2">Shared Context Summary</div>
          <div>{sharedSummary}</div>
        </CardContent>
      </Card>
    </div>
  );
}
