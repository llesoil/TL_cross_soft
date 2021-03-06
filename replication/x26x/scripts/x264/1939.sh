#!/bin/sh

numb='1940'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 2.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.8 --aq-mode 3 --b-adapt 0 --bframes 8 --crf 25 --keyint 230 --lookahead-threads 1 --min-keyint 22 --qp 50 --qpstep 3 --qpmin 4 --qpmax 63 --rc-lookahead 48 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.2,1.2,2.6,0.4,0.9,0.8,3,0,8,25,230,1,22,50,3,4,63,48,3,2000,-2:-2,dia,show,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"