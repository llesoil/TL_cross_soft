#!/bin/sh

numb='1012'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 0 --keyint 290 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset ultrafast --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.2,1.1,1.4,0.6,0.9,0.8,1,0,2,0,290,4,30,50,3,4,68,28,1,1000,-2:-2,dia,show,ultrafast,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"