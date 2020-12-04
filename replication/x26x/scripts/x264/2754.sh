#!/bin/sh

numb='2755'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 4.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 35 --keyint 280 --lookahead-threads 1 --min-keyint 27 --qp 20 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.0,1.2,4.2,0.2,0.9,0.9,2,1,8,35,280,1,27,20,4,3,64,18,1,2000,-1:-1,hex,crop,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"