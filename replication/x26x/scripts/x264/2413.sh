#!/bin/sh

numb='2414'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 0.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 35 --keyint 230 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.5,1.2,0.8,0.3,0.8,0.0,2,0,4,35,230,4,28,30,4,3,68,28,5,1000,1:1,dia,show,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"