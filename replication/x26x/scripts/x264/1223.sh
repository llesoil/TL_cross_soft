#!/bin/sh

numb='1224'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 4.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.6 --aq-mode 0 --b-adapt 1 --bframes 8 --crf 35 --keyint 200 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 4 --qpmin 1 --qpmax 68 --rc-lookahead 18 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,1.5,1.1,1.1,4.6,0.2,0.8,0.6,0,1,8,35,200,1,25,50,4,1,68,18,6,2000,-1:-1,dia,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"