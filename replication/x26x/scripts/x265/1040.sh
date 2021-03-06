#!/bin/sh

numb='1041'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --no-weightb --aq-strength 1.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 20 --keyint 250 --lookahead-threads 3 --min-keyint 22 --qp 30 --qpstep 4 --qpmin 0 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan show --preset veryfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--no-weightb,1.5,1.5,1.1,4.4,0.3,0.9,0.9,2,2,4,20,250,3,22,30,4,0,67,38,6,1000,-2:-2,hex,show,veryfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"