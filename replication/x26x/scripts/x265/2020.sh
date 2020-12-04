#!/bin/sh

numb='2021'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 0 --b-adapt 1 --bframes 16 --crf 35 --keyint 250 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slower --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.0,1.6,1.3,0.8,0.4,0.9,0.0,0,1,16,35,250,3,24,30,3,2,63,28,4,2000,-2:-2,hex,show,slower,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"