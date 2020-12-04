#!/bin/sh

numb='1806'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.5 --ipratio 1.5 --pbratio 1.3 --psy-rd 3.2 --qblur 0.3 --qcomp 0.8 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 10 --crf 10 --keyint 290 --lookahead-threads 3 --min-keyint 21 --qp 0 --qpstep 4 --qpmin 3 --qpmax 67 --rc-lookahead 18 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.5,1.5,1.3,3.2,0.3,0.8,0.5,1,2,10,10,290,3,21,0,4,3,67,18,6,1000,1:1,dia,show,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"