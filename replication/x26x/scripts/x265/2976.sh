#!/bin/sh

numb='2977'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.4 --psy-rd 0.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 35 --keyint 210 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset superfast --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,3.0,1.3,1.4,0.6,0.3,0.6,0.3,1,1,16,35,210,4,25,50,4,3,69,18,1,1000,1:1,hex,show,superfast,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"