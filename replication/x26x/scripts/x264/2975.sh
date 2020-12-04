#!/bin/sh

numb='2976'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 30 --keyint 230 --lookahead-threads 2 --min-keyint 29 --qp 40 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.2,1.1,4.8,0.5,0.9,0.4,1,2,10,30,230,2,29,40,3,3,65,38,6,1000,-2:-2,dia,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"