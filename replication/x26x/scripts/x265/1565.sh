#!/bin/sh

numb='1566'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 1.2 --qblur 0.6 --qcomp 0.6 --vbv-init 0.6 --aq-mode 0 --b-adapt 2 --bframes 10 --crf 25 --keyint 290 --lookahead-threads 0 --min-keyint 20 --qp 40 --qpstep 4 --qpmin 0 --qpmax 69 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.5,1.1,1.3,1.2,0.6,0.6,0.6,0,2,10,25,290,0,20,40,4,0,69,28,4,2000,1:1,umh,show,slower,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"