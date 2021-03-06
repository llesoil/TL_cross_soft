#!/bin/sh

numb='1708'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 10 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 20 --qp 30 --qpstep 3 --qpmin 4 --qpmax 61 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.1,2.2,0.2,0.6,0.6,3,0,10,40,260,0,20,30,3,4,61,38,2,1000,1:1,dia,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"