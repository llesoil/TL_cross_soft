#!/bin/sh

numb='1088'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 15 --keyint 260 --lookahead-threads 1 --min-keyint 29 --qp 40 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 48 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.4,1.1,2.0,0.5,0.7,0.8,2,1,4,15,260,1,29,40,4,0,65,48,1,2000,-1:-1,dia,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"