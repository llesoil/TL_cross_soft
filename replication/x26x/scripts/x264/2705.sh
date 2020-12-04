#!/bin/sh

numb='2706'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 4 --crf 10 --keyint 220 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 3 --qpmin 2 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset slower --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,2.5,1.6,1.2,0.2,0.4,0.9,0.1,2,2,4,10,220,1,22,40,3,2,67,48,4,2000,-1:-1,dia,crop,slower,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"