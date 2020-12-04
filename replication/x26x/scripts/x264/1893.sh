#!/bin/sh

numb='1894'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.0 --psy-rd 3.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 2 --bframes 14 --crf 0 --keyint 290 --lookahead-threads 3 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.0,3.0,0.3,0.6,0.5,3,2,14,0,290,3,22,50,3,2,63,18,1,2000,-1:-1,dia,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"