#!/bin/sh

numb='1114'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.9 --aq-mode 0 --b-adapt 0 --bframes 14 --crf 50 --keyint 230 --lookahead-threads 0 --min-keyint 27 --qp 10 --qpstep 4 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--weightb,0.5,1.5,1.1,4.6,0.4,0.9,0.9,0,0,14,50,230,0,27,10,4,0,61,48,4,2000,-2:-2,hex,show,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"