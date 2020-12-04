#!/bin/sh

numb='2622'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.2 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 50 --keyint 240 --lookahead-threads 0 --min-keyint 27 --qp 20 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.5,1.0,1.2,3.2,0.5,0.9,0.5,3,2,12,50,240,0,27,20,3,4,67,28,5,2000,-2:-2,umh,crop,superfast,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"