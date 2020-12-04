#!/bin/sh

numb='1681'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 1.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 16 --crf 10 --keyint 200 --lookahead-threads 1 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--no-weightb,2.0,1.5,1.3,1.8,0.4,0.9,0.8,2,0,16,10,200,1,24,50,4,3,68,18,4,1000,1:1,dia,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"