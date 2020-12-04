#!/bin/sh

numb='1281'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 35 --keyint 300 --lookahead-threads 0 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,1.5,1.1,1.3,1.4,0.2,0.8,0.9,0,2,12,35,300,0,27,40,4,0,65,48,4,2000,-2:-2,umh,show,ultrafast,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"