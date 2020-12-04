#!/bin/sh

numb='2725'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.1 --psy-rd 5.0 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 2 --b-adapt 2 --bframes 8 --crf 20 --keyint 220 --lookahead-threads 4 --min-keyint 29 --qp 30 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.5,1.6,1.1,5.0,0.3,0.8,0.4,2,2,8,20,220,4,29,30,5,3,69,18,5,1000,1:1,dia,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"