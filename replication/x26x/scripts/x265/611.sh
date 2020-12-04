#!/bin/sh

numb='612'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.5 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 5 --keyint 290 --lookahead-threads 2 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,3.0,1.1,1.3,2.8,0.3,0.7,0.5,1,0,10,5,290,2,25,20,3,3,66,18,4,1000,1:1,dia,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"