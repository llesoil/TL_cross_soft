#!/bin/sh

numb='1755'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.8 --qblur 0.3 --qcomp 0.6 --vbv-init 0.2 --aq-mode 3 --b-adapt 2 --bframes 12 --crf 50 --keyint 230 --lookahead-threads 0 --min-keyint 22 --qp 0 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,2.5,1.0,1.0,3.8,0.3,0.6,0.2,3,2,12,50,230,0,22,0,3,4,68,48,4,1000,-1:-1,dia,show,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"