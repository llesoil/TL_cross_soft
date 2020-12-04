#!/bin/sh

numb='1731'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.8 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 35 --keyint 230 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 1 --qpmax 67 --rc-lookahead 28 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset veryslow --scenecut 30 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.4,1.2,0.8,0.2,0.9,0.9,3,2,10,35,230,2,25,30,3,1,67,28,5,2000,1:1,umh,show,veryslow,30,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"